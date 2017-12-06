import { Collection, Model } from 'mobx-rest'

class MatchModel extends Model {
  get primaryKey() {
    return 'uuid'
  }
}

class MatchesCollection extends Collection {
  url() { return '/api/v1/matches' }
  model() { return MatchModel }
}

export default new MatchesCollection()
