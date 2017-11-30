import { Collection, Model } from 'mobx-rest'
import teams from './teams'

class ScheduleModel extends Model {
  get primaryKey() {
    return 'uuid'
  }

  get teams() {
    return teams.filter(this.get('schedule_uuid'))
  }
}

class SchedulesCollection extends Collection {
  url() { return '/api/v1/schedules' }
  model() { return ScheduleModel }
}

export default new SchedulesCollection()
