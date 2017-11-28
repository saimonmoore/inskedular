import { Collection, Model } from 'mobx-rest'

class TeamModel extends Model {}

class TeamsCollection extends Collection {
  url() { return '/api/v1/teams' }
  model() { return TeamModel }
}

export default new TeamsCollection()
