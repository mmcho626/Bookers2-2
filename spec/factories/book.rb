# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "title#{n}" }
    sequence(:body) { |n| "body#{n}" }

    trait :no_title do
      title {}
    end

    trait :no_body do
      body {}
    end

    trait :too_long_body do
      body {Faker::Lorem.characters(number: 201)}
    end
  end
end
