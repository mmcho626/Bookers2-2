# frozen_string_literal: true

FactoryBot.define do
  password = Faker::Internet.password

  factory :user do
    sequence(:email) { |n| "example#{n}@test.com" }
    sequence(:name) { |n| "name#{n}" }
    sequence(:introduction) { |n| "introduction#{n}" }
    password { password }
    password_confirmation { password }

    trait :no_name do
      name {}
    end

    trait :too_long_name do
      name {Faker::Lorem.characters(number: 21)}
    end

    trait :too_short_name do
      name {Faker::Lorem.characters(number: 1)}
    end

    trait :too_long_introduction do
      introduction {Faker::Lorem.characters(number: 51)}
    end

    trait :create_with_image do
      profile_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")}
    end

    trait :create_with_books do
      after(:create) do |user|
        create_list(:book, 3, user: user)
      end
    end
  end
end
