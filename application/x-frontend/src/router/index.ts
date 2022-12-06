import { createRouter, createWebHistory } from 'vue-router'

import Dealers from '~/pages/Dealers.vue'
import Dealer from '~/pages/Dealer.vue'
import Exports from '~/pages/Exports.vue'
import Users from '~/pages/Users.vue'
import Locations from '~/pages/Locations.vue'
import VinTool from '~/pages/VinTool.vue'
import VinToolEdit from '~/pages/VinToolEdit.vue'
import {
    DEALER,
    DEALERS,
    EXPORTS,
    LOCATIONS,
    VINTOOL,
    VINTOOL_EDIT
} from './route-names'

const routes = [
    {
        path: '/',
        redirect: { name: DEALERS },
    },
    {
        path: '/dealers',
        name: DEALERS,
        component: Dealers,
    },
    {
        path: '/dealer/:id',
        component: Dealer,
        props: true,
        children: [
            {
                path: '',
                name: DEALER,
                component: Users,
            },
            {
                path: 'locations',
                name: LOCATIONS,
                component: Locations,
            },
            {
                path: 'exports',
                name: EXPORTS,
                component: Exports,
            },
        ]
    },
    {
        path: '/vintool/:vin?',
        name: VINTOOL,
        component: VinTool,
        props: true,
        children: [{
            path: 'equipment/:eqcode',
            name: VINTOOL_EDIT,
            component: VinToolEdit,
            props: true
        }]
    }
]

export default createRouter({
    history: createWebHistory('/-/panel/'),
    routes,
})