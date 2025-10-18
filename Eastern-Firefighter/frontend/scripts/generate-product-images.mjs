#!/usr/bin/env node
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const API = process.env.API_BASE || 'http://localhost:8080/api';
const OUT_DIR = path.resolve(__dirname, '../public/images/products');
const COUNT = Number(process.env.MEDIA_COUNT || 3);

function randomColorFromId(id) {
	let n = Number(id) || 0;
	const r = (n * 37) % 255;
	const g = (n * 57) % 255;
	const b = (n * 97) % 255;
	return `rgb(${r}, ${g}, ${b})`;
}

function buildSvg({ id, name, index }) {
	const bg = randomColorFromId(id + index);
	const text = (name || `商品#${id}`).slice(0, 18);
	return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600">
	<defs>
		<linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
			<stop offset="0%" stop-color="${bg}" stop-opacity="0.85"/>
			<stop offset="100%" stop-color="#1e3a8a" stop-opacity="0.85"/>
		</linearGradient>
	</defs>
	<rect width="100%" height="100%" fill="url(#g)"/>
	<g fill="#ffffff" opacity="0.08">
		<circle cx="120" cy="120" r="100"/>
		<circle cx="700" cy="520" r="120"/>
		<rect x="520" y="60" width="180" height="120" rx="12"/>
	</g>
	<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', 'PingFang SC', 'Microsoft YaHei', sans-serif" font-size="42" fill="#ffffff" style="font-weight:700; letter-spacing:1px;">
		${text}
	</text>
	<text x="50%" y="58%" dominant-baseline="middle" text-anchor="middle" font-family="Arial, sans-serif" font-size="18" fill="#e5e7eb" style="opacity:.9">ID: ${id} · 图${index}</text>
</svg>`;
}

async function main(){
	console.log(`[generate] API_BASE=${API}`);
	await fs.mkdir(OUT_DIR, { recursive: true });

	const url = `${API}/commerce/products?page=1&size=1000`;
	const res = await fetch(url);
	if (!res.ok) throw new Error(`Fetch products failed: ${res.status} ${res.statusText}`);
	const body = await res.json();
	const records = body?.data?.records || [];
	console.log(`[generate] products: ${records.length}`);

	for (const p of records) {
		for (let i = 1; i <= COUNT; i++) {
			const svg = buildSvg({ id: p.id, name: p.name, index: i });
			const file = path.resolve(OUT_DIR, `${p.id}-${i}.svg`);
			await fs.writeFile(file, svg, 'utf8');
		}
	}
	console.log(`[generate] svg written per product: ${COUNT}`);

	// 设置 media_json：/images/products/{id}-{n}.svg
	const mediaUrl = new URL(`${API}/commerce/products/dev/set-media-patterns`);
	mediaUrl.searchParams.set('count', String(COUNT));
	mediaUrl.searchParams.set('pattern', '/images/products/{id}-{n}.svg');
	const updMedia = await fetch(mediaUrl, { method: 'POST' });
	if (!updMedia.ok) throw new Error(`Update media patterns failed: ${updMedia.status} ${updMedia.statusText}`);
	const updMediaBody = await updMedia.json();
	console.log(`[generate] media_json updated: ${updMediaBody?.data ?? 0}`);

	// 同步 coverUrl 为第一张图，便于列表页显示
	const coverUrl = new URL(`${API}/commerce/products/dev/set-cover-pattern`);
	coverUrl.searchParams.set('pattern', '/images/products/{id}-1.svg');
	const updCover = await fetch(coverUrl, { method: 'POST' });
	if (!updCover.ok) throw new Error(`Update cover pattern failed: ${updCover.status} ${updCover.statusText}`);
	const updCoverBody = await updCover.json();
	console.log(`[generate] cover_url updated: ${updCoverBody?.data ?? 0}`);

	console.log(`[generate] done. Example: /images/products/1-1.svg`);
}

main().catch((e) => { console.error(e); process.exit(1); }); 