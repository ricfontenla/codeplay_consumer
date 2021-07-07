require 'rails_helper'

describe 'homepage' do
  it 'view codeplay courses' do
    visit root_path

    expect((page)).to  have_content('Ruby Basico')
    expect((page)).to  have_content('John Doe')
    expect((page)).to  have_content('Um curso de Ruby')
    expect((page)).to  have_content('Ruby on Rails')
    expect((page)).to  have_content('John Doe')
    expect((page)).to  have_content('Um curso de Ruby on Rails')
  end
end