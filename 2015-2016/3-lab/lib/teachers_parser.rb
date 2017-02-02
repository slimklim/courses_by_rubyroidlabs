require 'mechanize'

class TeachersParser

  SCHEDULE_URL = 'http://www.bsuir.by/schedule/schedule.xhtml'
  FORM_NAME = 'studentGroupTab:j_idt21'
  INPUT_NAME = 'studentGroupTab:j_idt21:searchStudentGroup'
  BUTTON_NAME = 'studentGroupTab:j_idt21:j_idt26'
  TEACHER_NAME_REGEX = /\A[А-Я][а-я]*\s[А-Я]\.\s[А-Я]\.\Z/
  FIO_XPATH = '//*[@id="tableForm:schedulePanel"]/span/span'

  def initialize()
    @agent = Mechanize.new
    page = @agent.get(SCHEDULE_URL)
    @form = page.form(FORM_NAME)
  end

  # main method (num -> arr)
  def pull(group_number)
    @form[INPUT_NAME] = group_number
    button = @form.button_with(name: BUTTON_NAME)
    schedule_page = @agent.submit(@form, button)
    teachers_links = schedule_page.links.select { |t| TEACHER_NAME_REGEX === t.to_s }
    teachers_links.uniq(&:text).map { |t| t.click.search(FIO_XPATH).first.text }
  end

end




