import { Collection, Model } from 'mobx-rest'

class TeamModel extends Model {
  get primaryKey() {
    return 'uuid'
  }
}

class TeamsCollection extends Collection {
  url() { return '/api/v1/teams' }
  model() { return TeamModel }
}

export default new TeamsCollection()
