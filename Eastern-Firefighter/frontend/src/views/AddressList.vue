<template>
	<div class="page">
		<h2>地址管理</h2>
		<div class="form">
			<input v-model="form.contactName" placeholder="收货人" />
			<span v-if="errors.contactName" class="err">{{ errors.contactName }}</span>
			<input v-model="form.contactPhone" placeholder="电话" />
			<span v-if="errors.contactPhone" class="err">{{ errors.contactPhone }}</span>
			<input v-model="form.addressLine" placeholder="详细地址" />
			<span v-if="errors.addressLine" class="err">{{ errors.addressLine }}</span>
			<label><input type="checkbox" v-model="form.isDefaultBool" /> 设为默认</label>
			<button :disabled="!canSubmit || saving" @click="save">{{ saving ? '保存中..' : '保存' }}</button>
		</div>
		<div class="list">
			<div v-for="a in records" :key="a.id" class="row">
				<div>{{ a.contactName }} {{ a.contactPhone }} - {{ a.addressLine }} <span v-if="a.isDefault===1">[默认]</span></div>
				<div class="ops">
					<button @click="edit(a)">编辑</button>
					<button @click="setDefault(a)">设为默认</button>
					<button @click="remove(a)">删除</button>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import http from '@/api/http';
import { computed, onMounted, reactive, ref } from 'vue';

interface Address { id?: number; contactName: string; contactPhone: string; addressLine: string; isDefault?: number; }
const records = ref<Address[]>([]);
const form = reactive<any>({ id: undefined, contactName: '', contactPhone: '', addressLine: '', isDefaultBool: false });
const errors = reactive<any>({ contactName: '', contactPhone: '', addressLine: '' });
const saving = ref(false);

function validateForm(): boolean {
	errors.contactName = '';
	errors.contactPhone = '';
	errors.addressLine = '';
	const name = String(form.contactName || '').trim();
	const phone = String(form.contactPhone || '').trim();
	const addr = String(form.addressLine || '').trim();
	if (!name) errors.contactName = '请填写收货人';
	else if (name.length < 2 || name.length > 20) errors.contactName = '收货人长度需 2-20 个字符';
	const phoneRe = /^1[3-9]\d{9}$/;
	if (!phone) errors.contactPhone = '请填写电话';
	else if (!phoneRe.test(phone)) errors.contactPhone = '请输入有效的手机号';
	if (!addr) errors.addressLine = '请填写详细地址';
	else if (addr.length < 5) errors.addressLine = '详细地址不少于 5 个字符';
	return !(errors.contactName || errors.contactPhone || errors.addressLine);
}

const canSubmit = computed(() => validateForm());

async function load() {
	try {
	const { data } = await http.get('/auth/profile/addresses', { params: { page: 1, size: 20 } });
	records.value = data.data.records || [];
	} catch (e: any) {
		alert(e?.response?.data?.message || '加载地址失败');
	}
}

function edit(a: any) {
	form.id = a.id;
	form.contactName = a.contactName;
	form.contactPhone = a.contactPhone;
	form.addressLine = a.addressLine;
	form.isDefaultBool = a.isDefault === 1;
	validateForm();
}

async function save() {
	if (saving.value) return;
	if (!validateForm()) {
		const firstErr = errors.contactName || errors.contactPhone || errors.addressLine;
		return alert(firstErr);
	}
	saving.value = true;
	try {
	await http.post('/auth/profile/addresses/save', {
		id: form.id,
			contactName: String(form.contactName).trim(),
			contactPhone: String(form.contactPhone).trim(),
			addressLine: String(form.addressLine).trim(),
		isDefault: form.isDefaultBool ? 1 : 0
	});
	Object.assign(form, { id: undefined, contactName: '', contactPhone: '', addressLine: '', isDefaultBool: false });
		validateForm();
	await load();
		alert('保存成功');
	} catch (e: any) {
		alert(e?.response?.data?.message || '保存失败');
	} finally {
		saving.value = false;
	}
}

async function setDefault(a: any) {
	try {
	await http.post(`/auth/profile/addresses/${a.id}/default`);
	await load();
		alert('已设为默认地址');
	} catch (e: any) {
		alert(e?.response?.data?.message || '设置默认失败');
	}
}

async function remove(a: any) {
	if (!confirm('确认删除该地址吗？')) return;
	try {
	await http.post(`/auth/profile/addresses/${a.id}/delete`);
	await load();
		alert('删除成功');
	} catch (e: any) {
		alert(e?.response?.data?.message || '删除失败');
	}
}

onMounted(() => { validateForm(); load(); });
</script>

<style scoped>
.page { padding: 16px; display: grid; gap: 12px; }
.form { display: grid; gap: 8px; max-width: 520px; }
.list { display: grid; gap: 8px; }
.row { display: grid; grid-template-columns: 1fr auto; align-items: center; border: 1px solid #eee; border-radius: 8px; padding: 8px; }
.ops { display: flex; gap: 8px; }
.err { color: #c00; font-size: 12px; }
</style> 
