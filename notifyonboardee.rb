class NotifyOnboardee
  def self.progress(onboardee_id)
    #suppose que progression = % de tasks done / total de tasks
    nbr_onboardee_tasks = Task.where(onboardee_id: onboardee_id).length
    nbr_onboardee_tasks_done = Task.where(onboardee_id: onboardee_id, done: true).length
    return nbr_onboardee_tasks_done.fdiv(nbr_onboardee_tasks)
  end

  def self.tasks(onboardee_id)
    onboardee_tasks = Task.where(onboardee_id: onboardee_id, done: false).order(end_date: :asc)
    return onboardee_tasks
  end

  def self.alerted_tasks(onboardee_id)
    onboardee_tasks_late = Task.where("end_date < ? AND onboardee_id = ?", Date.today, onboardee_id).order(end_date: :asc)
    return onboardee_tasks_late
  end

  def self.alerted_tasks(manager_id)
    manager_tasks_late = Task.joins(:onboardee).where(onboardees: { manager_id: manager_id }).where("end_date < ?", Date.today).order(end_date: :asc)
    return manager_tasks_late
  end

  def self.done(task_name)
    task_to_change = Task.find_by(name: task_name) #serait pas plus logique avec task_id?
    task_to_change.done = true
    task_to_change.save
  end
end
