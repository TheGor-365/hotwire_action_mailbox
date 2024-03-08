class ApplicationMailbox < ActionMailbox::Base
  routing ReplayMailbox::MATCHER => :reply

  routing: :all => :conversation

  before_processing :save_attachments

  def form
    @form ||= mail[:form].address_list.addresses.first
  end

  def author
    if (user = User.find_by(email: from.address))
      user
    else
      content
    end
  end

  def contact
    contact = Contact.where(email: from.address).first_or_initialize
    contact.update(name: from.display_name)
    contact
  end

  def body
    if mail.multipart? && mail.html_part
      mail.html_part.body.decoded
    elsif mail.multipart? && mail.text_part
      mail.text_part.body.decoded
    else
      mail.decoded
    end
  end

  def save_attachments
    @attachments = mail.attachments.map do |attachment|
      blob = ActiveStorage::Blob.create_after_upload!(
        io: 'io',
        filename: 'filename',
        content_type: 'content_type'
      )
    end
  end
end
