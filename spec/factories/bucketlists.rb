FactoryGirl.define do
  factory :bucketlist do
    name "2016 goals"

    trait(:bucketlist2) do
      name "2017 parties"
      user_id 1
    end
  end
end