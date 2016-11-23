FactoryGirl.define do
  factory :user do
    password "app1234"
    username "mayowa"
    email "mayowaadegbola@yahoo.com"
    serial_no "123"

    trait(:user2) do
      username "mj"
      email "mj@gmail.com"
    end
  end
end