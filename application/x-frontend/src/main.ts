import App from "./App.vue";
import router from "./router";
import { createApp } from "vue";
import { createPinia } from 'pinia'
import resetStore from '~/stores/plugins/reset-store'

import ElementPlus from "element-plus";
import de from 'element-plus/es/locale/lang/de'

import "~/styles/index.scss";
import 'uno.css'

//// If you want to use ElMessage, import it.
//import "element-plus/theme-chalk/src/message.scss"

const pinia = createPinia()
pinia.use(resetStore)
const app = createApp(App);
app.use(router)
app.use(pinia)
app.use(ElementPlus, { locale: de })
app.mount("#app")
