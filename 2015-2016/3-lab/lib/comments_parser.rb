require 'mechanize'

class CommentsParser

  TEACHERS_LIST_URL = 'http://bsuir-helper.ru/lectors'
  COMMENTS_BOX_XPATH = 'div[id="comments"]'
  COMMENT_XPATH = '//div[starts-with(@class,"comment")]'
  COMMENT_DATE_XPATH = 'span[class="comment-date"]'
  COMMENT_TEXT_XPATH = 'div[class="content"]'
  NOT_FOUND = [{date: '', text: 'Не найдено отзывов'}]

  def initialize()
    @agent = Mechanize.new
    @page = @agent.get(TEACHERS_LIST_URL)
  end

  # main method (arr -> arr)
  def pull(teachers)

    teachers.map do |teacher|
      teacher_link = @page.link_with(text: teacher)
      teacher_link ? get_comments(teacher_link) : {name: teacher, comments: NOT_FOUND}
    end
  end

  private

    # get comments about teacher (str -> arr)
    def get_comments(teacher_link)
      teacher_page = teacher_link.click
      comments_box = teacher_page.search(COMMENTS_BOX_XPATH)
      comments = comments_box ?
        parse_comments(comments_box) : NOT_FOUND
      {name: teacher_link.text, comments: comments}
    end

    # parse date and text of comment (nodeset -> arr)
    def parse_comments(comments_box)
      comments = comments_box.search(COMMENT_XPATH)
      comments.map do |comment|
        date = comment.search(COMMENT_DATE_XPATH).text
        text = comment.search(COMMENT_TEXT_XPATH).text
        {date: "Date: #{date}", text: text}
      end
    end

end