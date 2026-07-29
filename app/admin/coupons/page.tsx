'use client';
import { money } from '@/lib/format-money';

import { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';

type CouponType = 'percentage' | 'fixed_amount' | 'free_shipping';

interface CouponRow {
  id: string;
  code: string;
  type: CouponType;
  value: number;
  minPurchase: number;
  usageLimit: number | null;
  usedCount: number;
  startDate: string;
  endDate: string | null;
  status: string;
  isActive: boolean;
  rawStartDate: string | null;
  rawEndDate: string | null;
}

const emptyForm = {
  code: '',
  type: 'percentage' as CouponType,
  value: '10',
  minPurchase: '0',
  usageLimit: '',
  startDate: '',
  endDate: '',
  isActive: true,
};

export default function AdminCouponsPage() {
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [editingCoupon, setEditingCoupon] = useState<CouponRow | null>(null);
  const [coupons, setCoupons] = useState<CouponRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState(emptyForm);
  const [formError, setFormError] = useState<string | null>(null);

  useEffect(() => {
    fetchCoupons();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- run once on mount
  }, []);

  const authHeaders = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    return session?.access_token ? { Authorization: `Bearer ${session.access_token}` } : {};
  };

  const mapCoupon = (c: any): CouponRow => ({
    id: c.id,
    code: c.code,
    type: c.type || 'percentage',
    value: Number(c.value) || 0,
    minPurchase: Number(c.minimum_purchase) || 0,
    usageLimit: c.usage_limit ?? null,
    usedCount: Number(c.usage_count) || 0,
    startDate: c.start_date ? new Date(c.start_date).toLocaleDateString() : 'N/A',
    endDate: c.end_date ? new Date(c.end_date).toLocaleDateString() : null,
    status: getCouponStatus(c),
    isActive: c.is_active !== false,
    rawStartDate: c.start_date ? c.start_date.slice(0, 10) : null,
    rawEndDate: c.end_date ? c.end_date.slice(0, 10) : null,
  });

  const getCouponStatus = (c: any) => {
    if (!c.is_active) return 'Disabled';
    if (c.start_date && new Date(c.start_date) > new Date()) return 'Scheduled';
    if (c.end_date && new Date(c.end_date) < new Date()) return 'Expired';
    return 'Active';
  };

  const fetchCoupons = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/admin/coupons', {
        credentials: 'include',
        headers: await authHeaders(),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || 'Failed to fetch coupons');
      setCoupons((json.coupons || []).map(mapCoupon));
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const openAddModal = () => {
    setForm(emptyForm);
    setFormError(null);
    setShowAddModal(true);
  };

  const openEditModal = (coupon: CouponRow) => {
    setEditingCoupon(coupon);
    setForm({
      code: coupon.code,
      type: coupon.type,
      value: String(coupon.value),
      minPurchase: String(coupon.minPurchase),
      usageLimit: coupon.usageLimit != null ? String(coupon.usageLimit) : '',
      startDate: coupon.rawStartDate || '',
      endDate: coupon.rawEndDate || '',
      isActive: coupon.isActive,
    });
    setFormError(null);
    setShowEditModal(true);
  };

  const closeModal = () => {
    setShowAddModal(false);
    setShowEditModal(false);
    setEditingCoupon(null);
    setFormError(null);
  };

  const handleSave = async () => {
    setSaving(true);
    setFormError(null);
    try {
      const payload = {
        code: form.code,
        type: form.type,
        value: form.type === 'free_shipping' ? 0 : Number(form.value),
        minPurchase: Number(form.minPurchase) || 0,
        usageLimit: form.usageLimit ? Number(form.usageLimit) : null,
        startDate: form.startDate || null,
        endDate: form.endDate || null,
        isActive: form.isActive,
      };

      const url = showEditModal && editingCoupon
        ? `/api/admin/coupons/${editingCoupon.id}`
        : '/api/admin/coupons';
      const method = showEditModal ? 'PATCH' : 'POST';

      const res = await fetch(url, {
        method,
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
          ...(await authHeaders()),
        },
        body: JSON.stringify(payload),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || 'Failed to save coupon');

      await fetchCoupons();
      closeModal();
    } catch (err: any) {
      setFormError(err.message || 'Failed to save coupon');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (coupon: CouponRow) => {
    if (!confirm(`Delete coupon "${coupon.code}"?`)) return;
    try {
      const res = await fetch(`/api/admin/coupons/${coupon.id}`, {
        method: 'DELETE',
        credentials: 'include',
        headers: await authHeaders(),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error || 'Failed to delete coupon');
      await fetchCoupons();
    } catch (err: any) {
      alert(err.message || 'Failed to delete coupon');
    }
  };

  const copyCode = async (code: string) => {
    try {
      await navigator.clipboard.writeText(code);
    } catch {
      // ignore
    }
  };

  const statusColors: Record<string, string> = {
    Active: 'bg-gray-100 text-gray-900',
    Scheduled: 'bg-blue-100 text-blue-700',
    Expired: 'bg-gray-100 text-gray-700',
    Disabled: 'bg-red-100 text-red-700',
  };

  const activeCoupons = coupons.filter((c) => c.status === 'Active');
  const totalUses = coupons.reduce((sum, c) => sum + c.usedCount, 0);

  const formatValue = (coupon: CouponRow) => {
    if (coupon.type === 'percentage') return `${coupon.value}%`;
    if (coupon.type === 'fixed_amount') return `GH₵ ${money(coupon.value)}`;
    return 'Free Shipping';
  };

  const renderModal = () => {
    if (!showAddModal && !showEditModal) return null;

    return (
      <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
        <div className="bg-white p-8 rounded-lg max-w-lg w-full max-h-[90vh] overflow-y-auto">
          <h2 className="text-xl font-bold mb-4">
            {showEditModal ? 'Edit Coupon' : 'Create Coupon'}
          </h2>

          {formError && (
            <div className="mb-4 p-3 bg-red-50 text-red-700 rounded-lg text-sm">{formError}</div>
          )}

          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1">Code</label>
              <input
                type="text"
                value={form.code}
                onChange={(e) => setForm({ ...form, code: e.target.value.toUpperCase() })}
                className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg font-mono uppercase"
                placeholder="SAVE10"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1">Type</label>
              <select
                value={form.type}
                onChange={(e) => setForm({ ...form, type: e.target.value as CouponType })}
                className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
              >
                <option value="percentage">Percentage off</option>
                <option value="fixed_amount">Fixed amount off</option>
                <option value="free_shipping">Free shipping</option>
              </select>
            </div>

            {form.type !== 'free_shipping' && (
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">
                  {form.type === 'percentage' ? 'Discount (%)' : 'Discount (GH₵)'}
                </label>
                <input
                  type="number"
                  min="0"
                  step={form.type === 'percentage' ? '1' : '0.01'}
                  value={form.value}
                  onChange={(e) => setForm({ ...form, value: e.target.value })}
                  className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
                />
              </div>
            )}

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1">Minimum purchase (GH₵)</label>
              <input
                type="number"
                min="0"
                step="0.01"
                value={form.minPurchase}
                onChange={(e) => setForm({ ...form, minPurchase: e.target.value })}
                className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1">Usage limit (optional)</label>
              <input
                type="number"
                min="1"
                value={form.usageLimit}
                onChange={(e) => setForm({ ...form, usageLimit: e.target.value })}
                className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
                placeholder="Unlimited"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">Start date</label>
                <input
                  type="date"
                  value={form.startDate}
                  onChange={(e) => setForm({ ...form, startDate: e.target.value })}
                  className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
                />
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1">End date</label>
                <input
                  type="date"
                  value={form.endDate}
                  onChange={(e) => setForm({ ...form, endDate: e.target.value })}
                  className="w-full px-3 py-2 border-2 border-gray-300 rounded-lg"
                />
              </div>
            </div>

            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={form.isActive}
                onChange={(e) => setForm({ ...form, isActive: e.target.checked })}
                className="w-4 h-4"
              />
              <span className="text-sm font-medium text-gray-700">Active</span>
            </label>
          </div>

          <div className="flex gap-3 mt-6">
            <button
              onClick={handleSave}
              disabled={saving}
              className="px-4 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 disabled:opacity-50"
            >
              {saving ? 'Saving...' : showEditModal ? 'Update Coupon' : 'Create Coupon'}
            </button>
            <button
              onClick={closeModal}
              className="px-4 py-2 bg-gray-200 rounded-lg hover:bg-gray-300"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Coupons & Promotions</h1>
          <p className="text-gray-600 mt-1">Create and manage discount codes</p>
        </div>
        <button
          onClick={openAddModal}
          className="bg-gray-900 hover:bg-gray-800 text-white px-6 py-3 rounded-lg font-semibold transition-colors whitespace-nowrap cursor-pointer"
        >
          <i className="ri-add-line mr-2"></i>
          Create Coupon
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl border-2 border-gray-200 p-4">
          <p className="text-sm text-gray-600 mb-1">Total Coupons</p>
          <p className="text-2xl font-bold text-gray-900">{coupons.length}</p>
        </div>
        <div className="bg-white rounded-xl border-2 border-gray-200 p-4">
          <p className="text-sm text-gray-600 mb-1">Active</p>
          <p className="text-2xl font-bold text-gray-900">{activeCoupons.length}</p>
        </div>
        <div className="bg-white rounded-xl border-2 border-gray-200 p-4">
          <p className="text-sm text-gray-600 mb-1">Total Uses</p>
          <p className="text-2xl font-bold text-gray-900">{totalUses}</p>
        </div>
        <div className="bg-white rounded-xl border-2 border-gray-200 p-4">
          <p className="text-sm text-gray-600 mb-1">Total Discount</p>
          <p className="text-2xl font-bold text-purple-700">--</p>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-gray-200">
        <div className="p-6 border-b border-gray-200">
          <h2 className="text-lg font-bold text-gray-900">All Coupons</h2>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left py-4 px-6 text-sm font-semibold text-gray-700">Code</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Type</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Value</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Min Purchase</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Usage</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Valid Period</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Status</th>
                <th className="text-left py-4 px-4 text-sm font-semibold text-gray-700">Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={8} className="p-8 text-center text-gray-500">Loading coupons...</td></tr>
              ) : coupons.length === 0 ? (
                <tr><td colSpan={8} className="p-8 text-center text-gray-500">No coupons found.</td></tr>
              ) : (
                coupons.map((coupon) => (
                  <tr key={coupon.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                    <td className="py-4 px-6">
                      <div className="flex items-center space-x-2">
                        <span className="font-mono font-bold text-gray-900 bg-gray-100 px-3 py-1 rounded">{coupon.code}</span>
                        <button
                          onClick={() => copyCode(coupon.code)}
                          className="w-7 h-7 flex items-center justify-center text-gray-400 hover:text-gray-900 hover:bg-gray-50 rounded transition-colors cursor-pointer"
                        >
                          <i className="ri-file-copy-line"></i>
                        </button>
                      </div>
                    </td>
                    <td className="py-4 px-4 text-gray-700 capitalize">{coupon.type.replace('_', ' ')}</td>
                    <td className="py-4 px-4 font-semibold text-gray-900">{formatValue(coupon)}</td>
                    <td className="py-4 px-4 text-gray-700 whitespace-nowrap">
                      {coupon.minPurchase > 0 ? `GH₵ ${money(coupon.minPurchase)}` : 'No minimum'}
                    </td>
                    <td className="py-4 px-4">
                      <div className="flex items-center space-x-2">
                        <span className="text-gray-900 font-semibold">{coupon.usedCount}</span>
                        <span className="text-gray-500">/</span>
                        <span className="text-gray-600">{coupon.usageLimit ?? '∞'}</span>
                      </div>
                    </td>
                    <td className="py-4 px-4">
                      <p className="text-sm text-gray-700 whitespace-nowrap">{coupon.startDate}</p>
                      <p className="text-sm text-gray-500 whitespace-nowrap">{coupon.endDate || 'No expiry'}</p>
                    </td>
                    <td className="py-4 px-4">
                      <span className={`px-3 py-1 rounded-full text-xs font-semibold whitespace-nowrap ${statusColors[coupon.status] || 'bg-gray-100'}`}>
                        {coupon.status}
                      </span>
                    </td>
                    <td className="py-4 px-4">
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => openEditModal(coupon)}
                          className="w-8 h-8 flex items-center justify-center text-gray-600 hover:text-blue-700 hover:bg-blue-50 rounded-lg transition-colors cursor-pointer"
                        >
                          <i className="ri-edit-line text-lg"></i>
                        </button>
                        <button
                          onClick={() => handleDelete(coupon)}
                          className="w-8 h-8 flex items-center justify-center text-gray-600 hover:text-red-700 hover:bg-red-50 rounded-lg transition-colors cursor-pointer"
                        >
                          <i className="ri-delete-bin-line text-lg"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {renderModal()}
    </div>
  );
}
