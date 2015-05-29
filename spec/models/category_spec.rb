require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Some Category")
    category.save

    expect(category.valid?).to eq(true)
  end

  it { should have_many :videos }
end
