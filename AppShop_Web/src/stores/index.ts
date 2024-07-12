import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate'

const store = createStore({
  state() {
    return {
      id: '',
      token: '0',
      islogin: false,
      appID: '0',
      commitID:'0'
    }
  },
  mutations: {
    setid(state, id) {
      state.id = id
    },
    settoken(state, token) {
      state.token = token
    },
    setlogin(state, islogin) {
      state.islogin = islogin
    },
    setappID(state, appID) {
      state.appID = appID
    },
    setcommitID(state,commitID) {
      state.commitID = commitID
    }
  },
  actions: {
    id_save({ commit }, id) {
      commit('setid', id)
    },
    token_save({ commit }, token) {
      commit('settoken', token)
    },
    login_save({ commit }, status) {
      commit('setlogin', status)
    },
    appID_save({ commit }, appID) {
      commit('setappID', appID)
    },
    commitID_save({ commit }, commitID) {
      commit('setcommitID', commitID)
    },
  },
  plugins: [createPersistedState({ storage: sessionStorage })]}
)

export default store
