<template>
  <div class="article-editor">
    <div class="header">
      <h1>{{ isEdit ? '编辑文章' : '新建文章' }}</h1>
      <div class="actions">
        <button @click="saveDraft" class="btn btn-secondary" :disabled="saving">保存草稿</button>
        <button @click="publish" class="btn btn-primary" :disabled="saving">{{ isEdit ? '更新并发布' : '发布' }}</button>
        <router-link to="/admin/articles" class="btn btn-outline">取消</router-link>
      </div>
    </div>

    <form @submit.prevent="submit" class="editor-form">
      <div class="form-row">
        <div class="form-group">
          <label>标题 *</label>
          <input 
            v-model="form.title" 
            type="text" 
            required 
            maxlength="200"
            placeholder="请输入文章标题"
            class="form-control"
          />
        </div>
        <div class="form-group">
          <label>频道 *</label>
          <select v-model="form.channel" required class="form-control">
            <option value="">请选择频道</option>
            <option value="safety">安全科普</option>
            <option value="news">新闻资讯</option>
            <option value="guide">使用指南</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>URL别名 *</label>
          <input 
            v-model="form.slug" 
            type="text" 
            required 
            maxlength="100"
            placeholder="用于生成文章链接，如: fire-safety-tips"
            class="form-control"
          />
        </div>
      </div>

      <div class="form-group">
        <label>摘要</label>
        <textarea 
          v-model="form.summary" 
          rows="3" 
          maxlength="500"
          placeholder="请输入文章摘要，将显示在文章列表中"
          class="form-control"
        ></textarea>
      </div>

      <div class="form-group">
        <label>封面图片</label>
        <div class="cover-upload">
          <div v-if="form.coverUrl" class="cover-preview">
            <img :src="form.coverUrl" alt="封面预览" />
            <button type="button" @click="form.coverUrl = ''" class="remove-btn">×</button>
          </div>
          <div v-else class="upload-placeholder">
            <input type="file" @change="uploadCover" accept="image/*" class="file-input" />
            <div class="upload-text">
              <div>点击上传封面图片</div>
              <small>支持 JPG、PNG 格式，不超过 5MB</small>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label>文章内容 *</label>
        <div class="editor-toolbar">
          <button type="button" @click="insertImage" class="toolbar-btn">插入图片</button>
          <button type="button" @click="toggleBold" class="toolbar-btn">粗体</button>
          <button type="button" @click="toggleItalic" class="toolbar-btn">斜体</button>
          <button type="button" @click="insertLink" class="toolbar-btn">链接</button>
        </div>
        <div class="editor-container">
          <textarea 
            ref="contentEditor"
            v-model="form.contentHtml" 
            required
            rows="20"
            placeholder="请输入文章内容，支持HTML格式"
            class="content-editor"
          ></textarea>
          <div class="editor-preview" v-html="form.contentHtml"></div>
        </div>
      </div>
    </form>

    <!-- 图片上传模态框 -->
    <div v-if="showImageUpload" class="modal-overlay" @click="showImageUpload = false">
      <div class="modal" @click.stop>
        <div class="modal-header">
          <h3>上传图片</h3>
          <button @click="showImageUpload = false" class="close-btn">×</button>
        </div>
        <div class="modal-body">
          <input type="file" @change="uploadImage" accept="image/*" class="file-input" />
          <div class="upload-tip">
            支持 JPG、PNG 格式，不超过 5MB
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import http from '@/api/http'

const route = useRoute()
const router = useRouter()

const isEdit = ref(false)
const saving = ref(false)
const showImageUpload = ref(false)
const contentEditor = ref<HTMLTextAreaElement>()

const form = ref({
  title: '',
  channel: '',
  slug: '',
  summary: '',
  coverUrl: '',
  contentHtml: '',
  status: 1
})

async function loadArticle() {
  const id = route.params.id
  if (!id || id === 'create') {
    isEdit.value = false
    return
  }
  
  isEdit.value = true
  try {
    const { data } = await http.get(`/admin/articles/${id}`)
    const article = data.data
    form.value = {
      title: article.title,
      channel: article.channel,
      slug: article.slug,
      summary: article.summary || '',
      coverUrl: article.coverUrl || '',
      contentHtml: article.contentHtml,
      status: article.status
    }
  } catch (e: any) {
    alert('加载文章失败：' + (e.response?.data?.message || e.message))
    router.push('/admin/articles')
  }
}

async function saveDraft() {
  form.value.status = 0
  await save()
}

async function publish() {
  form.value.status = 1
  await save()
}

async function save() {
  if (!form.value.title || !form.value.channel || !form.value.slug || !form.value.contentHtml) {
    alert('请填写必填字段')
    return
  }
  
  saving.value = true
  try {
    if (isEdit.value) {
      await http.put(`/admin/articles/${route.params.id}`, form.value)
      alert('更新成功')
    } else {
      await http.post('/admin/articles', form.value)
      alert('创建成功')
    }
    router.push('/admin/articles')
  } catch (e: any) {
    alert('保存失败：' + (e.response?.data?.message || e.message))
  } finally {
    saving.value = false
  }
}

async function uploadCover(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  
  const formData = new FormData()
  formData.append('file', file)
  
  try {
    const { data } = await http.post('/admin/articles/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    form.value.coverUrl = data.data.url
  } catch (e: any) {
    alert('上传失败：' + (e.response?.data?.message || e.message))
  }
}

function insertImage() {
  showImageUpload.value = true
}

async function uploadImage(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  
  const formData = new FormData()
  formData.append('file', file)
  
  try {
    const { data } = await http.post('/admin/articles/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    
    // 插入图片到编辑器
    const imageHtml = `<img src="${data.data.url}" alt="图片" style="max-width: 100%; height: auto;" />`
    insertAtCursor(imageHtml)
    
    showImageUpload.value = false
  } catch (e: any) {
    alert('上传失败：' + (e.response?.data?.message || e.message))
  }
}

function insertAtCursor(text: string) {
  const textarea = contentEditor.value
  if (!textarea) return
  
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const before = form.value.contentHtml.substring(0, start)
  const after = form.value.contentHtml.substring(end)
  
  form.value.contentHtml = before + text + after
  
  // 设置光标位置
  setTimeout(() => {
    textarea.selectionStart = textarea.selectionEnd = start + text.length
    textarea.focus()
  })
}

function toggleBold() {
  insertAtCursor('<strong>粗体文字</strong>')
}

function toggleItalic() {
  insertAtCursor('<em>斜体文字</em>')
}

function insertLink() {
  const url = prompt('请输入链接地址:')
  if (url) {
    insertAtCursor(`<a href="${url}" target="_blank">链接文字</a>`)
  }
}

function submit() {
  publish()
}

onMounted(loadArticle)
</script>

<style scoped>
.article-editor {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.actions {
  display: flex;
  gap: 12px;
}

.editor-form {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group {
  flex: 1;
  margin-bottom: 24px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #333;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.form-control:focus {
  outline: none;
  border-color: #1976d2;
}

.cover-upload {
  border: 2px dashed #ddd;
  border-radius: 8px;
  position: relative;
}

.cover-preview {
  position: relative;
}

.cover-preview img {
  width: 100%;
  max-height: 200px;
  object-fit: cover;
  border-radius: 6px;
}

.remove-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 24px;
  height: 24px;
  border: none;
  border-radius: 50%;
  background: rgba(0,0,0,0.6);
  color: white;
  cursor: pointer;
  font-size: 16px;
  line-height: 1;
}

.upload-placeholder {
  padding: 40px;
  text-align: center;
  position: relative;
}

.file-input {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
}

.upload-text {
  color: #666;
}

.upload-text small {
  display: block;
  margin-top: 8px;
  color: #999;
}

.editor-toolbar {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
  padding: 8px;
  background: #f8f9fa;
  border-radius: 4px;
}

.toolbar-btn {
  padding: 6px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
  font-size: 12px;
  transition: all 0.2s;
}

.toolbar-btn:hover {
  background: #e9ecef;
}

.editor-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  height: 500px;
}

.content-editor {
  width: 100%;
  height: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 13px;
  resize: none;
}

.editor-preview {
  height: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: #fafafa;
  overflow-y: auto;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.2s;
}

.btn-primary {
  background: #1976d2;
  color: white;
}

.btn-secondary {
  background: #757575;
  color: white;
}

.btn-outline {
  background: transparent;
  color: #666;
  border: 1px solid #ddd;
}

.btn:hover {
  opacity: 0.8;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: white;
  border-radius: 8px;
  width: 400px;
  max-width: 90vw;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
}

.modal-body {
  padding: 20px;
}

.upload-tip {
  margin-top: 12px;
  font-size: 12px;
  color: #666;
}
</style> 