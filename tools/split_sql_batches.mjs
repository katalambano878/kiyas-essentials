import fs from "node:fs";
import path from "node:path";

const maxBytes = 11000;

function splitStatements(sql) {
  const out = [];
  let buf = "";
  let depth = 0;
  let inSingle = false;
  let inDouble = false;
  let inDollar = null;
  let i = 0;

  const pushBuf = () => {
    const t = buf.trim();
    if (t) out.push(t);
    buf = "";
  };

  while (i < sql.length) {
    const c = sql[i];
    const next = sql[i + 1];

    if (inDollar) {
      if (sql.startsWith(inDollar, i)) {
        buf += sql.slice(i, i + inDollar.length);
        i += inDollar.length;
        inDollar = null;
        continue;
      }
      buf += c;
      i++;
      continue;
    }

    if (!inSingle && !inDouble && c === "$" && /[$\d]/.test(next ?? "")) {
      const rest = sql.slice(i);
      const m = rest.match(/^\$([a-zA-Z_]*)\$/);
      if (m) {
        inDollar = m[0];
        buf += inDollar;
        i += inDollar.length;
        continue;
      }
    }

    if (!inDouble && c === "'" && !inSingle) {
      inSingle = true;
      buf += c;
      i++;
      continue;
    }
    if (inSingle) {
      buf += c;
      if (c === "'" && sql[i + 1] === "'") {
        buf += "'";
        i += 2;
        continue;
      }
      if (c === "'") inSingle = false;
      i++;
      continue;
    }

    if (!inSingle && c === '"') {
      inDouble = !inDouble;
      buf += c;
      i++;
      continue;
    }

    if (!inSingle && !inDouble) {
      if (c === "(") depth++;
      else if (c === ")" && depth > 0) depth--;
      else if (c === ";" && depth === 0) {
        buf += c;
        i++;
        pushBuf();
        continue;
      }
    }

    buf += c;
    i++;
  }
  pushBuf();
  return out;
}

function chunkStatements(stmts) {
  const batches = [];
  let cur = "";
  for (const s of stmts) {
    const piece = (cur ? "\n\n" : "") + s;
    if (Buffer.byteLength(cur + piece, "utf8") > maxBytes && cur) {
      batches.push(cur.trim());
      cur = s;
    } else {
      cur += piece;
    }
  }
  if (cur.trim()) batches.push(cur.trim());
  return batches;
}

const inFile = process.argv[2];
const outPrefix = process.argv[3];
if (!inFile || !outPrefix) {
  console.error("Usage: node split_sql_batches.mjs <input.sql> <outPrefix>");
  process.exit(1);
}

const sql = fs.readFileSync(inFile, "utf8");
const stmts = splitStatements(sql);
const batches = chunkStatements(stmts);
const dir = path.dirname(outPrefix);
if (dir && dir !== ".") fs.mkdirSync(dir, { recursive: true });

batches.forEach((q, idx) => {
  const name = `${path.basename(outPrefix)}_${idx}`;
  const payload = { name, query: q.endsWith(";") ? q : `${q};` };
  fs.writeFileSync(`${outPrefix}_${idx}.json`, JSON.stringify(payload));
  fs.writeFileSync(`${outPrefix}_${idx}.sql`, payload.query);
});

console.log(JSON.stringify({ statements: stmts.length, batches: batches.length }, null, 2));
