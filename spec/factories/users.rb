FactoryBot.define do
  factory :user do
    factory :user_1 do
      name { "taro" }
      email { "sample_taro@example.com" }
      password { "password"}
      encrypted_password { "password" }
      admin { false }
      line_alert { true }
    end

    factory :admin do
      name { "hanako" }
      email { "sample_hanako@example.com" }
      password { "password"}
      encrypted_password { "password" }
      admin { true }
      line_alert { true }
    end
  end
end
