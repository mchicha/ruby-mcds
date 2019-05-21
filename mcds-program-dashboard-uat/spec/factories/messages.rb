FactoryGirl.define do
  factory :message do
    subject "Test Subject"
    content "MyText"
    sent false
    send_date "2015-02-18 14:05:13"
    archived false
    publish_date "2015-02-18 14:05:13"
    archive_date "2015-02-18 14:05:13"
    delivery_type "MyString"
    user factory: :user
  end

  trait :that_is_sent do
    sent true
  end

  trait :published_message do
    archived false
    publish_date "2015-02-18 14:05:13"
    archive_date "2015-02-18 14:05:13"
  end

  trait :archived_message do
    archived true
  end

  trait :that_has_recipients do
    users { [FactoryGirl.create(:user)] }
  end

end
