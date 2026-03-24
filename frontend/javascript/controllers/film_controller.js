import { Controller } from "@hotwired/stimulus"

const CHANNEL_ID = "UCAvOpOyir3DpgWR-bEuKbMw"
const MEDIA_NS = "http://search.yahoo.com/mrss/"
const SKELETON_COUNT = 6

const SKELETON_CARD = `
  <div class="overflow-hidden rounded border border-slate-100 animate-pulse">
    <div class="w-full aspect-video bg-slate-100"></div>
    <div class="p-3 space-y-2">
      <div class="h-3.5 bg-slate-100 rounded w-3/4"></div>
      <div class="h-2.5 bg-slate-100 rounded w-1/3"></div>
    </div>
  </div>
`

export default class extends Controller {
  static targets = ["grid", "error"]

  connect() {
    this.gridTarget.innerHTML = Array(SKELETON_COUNT).fill(SKELETON_CARD).join("")
    this.gridTarget.hidden = false
    this.loadVideos()
  }

  async loadVideos() {
    const feedUrl = `https://www.youtube.com/feeds/videos.xml?channel_id=${CHANNEL_ID}`
    const proxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent(feedUrl)}`

    try {
      const res = await fetch(proxyUrl)
      if (!res.ok) throw new Error(res.statusText)

      const xml = await res.text()
      const doc = new DOMParser().parseFromString(xml, "text/xml")
      const entries = [...doc.querySelectorAll("entry")]

      const videos = entries
        .map(entry => {
          const videoId = entry.querySelector("id")?.textContent?.split(":").pop()
          const title = entry.querySelector("title")?.textContent
          const published = entry.querySelector("published")?.textContent?.slice(0, 10)
          const thumbnail =
            entry.getElementsByTagNameNS(MEDIA_NS, "thumbnail")[0]?.getAttribute("url") ??
            `https://i.ytimg.com/vi/${videoId}/hqdefault.jpg`

          return { videoId, title, published, thumbnail }
        })
        .filter(v => v.videoId && v.title)

      this.gridTarget.innerHTML = videos.map(v => this.videoCard(v)).join("")
    } catch (err) {
      console.error("Failed to load YouTube videos:", err)
      this.gridTarget.hidden = true
      this.errorTarget.hidden = false
    }
  }

  videoCard({ videoId, title, published, thumbnail }) {
    return `
      <a href="https://www.youtube.com/watch?v=${videoId}"
         target="_blank" rel="noopener"
         class="group flex flex-col h-full">
        <div class="flex flex-col h-full overflow-hidden rounded border border-slate-100 group-hover:border-slate-300 transition-colors duration-150">
          <img src="${thumbnail}" alt="" class="w-full aspect-video object-cover" loading="lazy">
          <div class="p-3 flex flex-col flex-1">
            <p class="text-sm font-medium text-slate-900 m-0 mb-1 leading-snug" style="display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden">${title}</p>
            <time class="text-xs text-slate-400 mt-auto pt-1">${published}</time>
          </div>
        </div>
      </a>
    `
  }
}
