require 'rails_helper'

describe 'homepage' do
  it 'view codeplay courses' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 200,
                                         body: File.read(Rails.root.join('spec/fixtures/courses.json')))
    )

    visit root_path

    expect((page)).to  have_content('Ruby Basico')
    expect((page)).to  have_content('John Doe')
    expect((page)).to  have_content('Um curso de Ruby')
    expect((page)).to  have_content('Ruby on Rails')
    expect((page)).to  have_content('Josermilson')
    expect((page)).to  have_content('Um curso de Ruby on Rails')
    expect((page)).to  have_content('HTML')
    expect((page)).to  have_content('Fulano Fulano')
    expect((page)).to  have_content('Um curso de HTML')
  end

  it 'and API not responding' do
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed, nil)

    visit root_path

    expect((page)).to have_content('Site temporariamente indisponível')
  end

  it 'and API connection timeout' do
    allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

    visit root_path

    expect((page)).to have_content('Site temporariamente indisponível')
  end

  it 'and API return status 500' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 500)
    )

    visit root_path

    expect((page)).to have_content('Site temporariamente indisponível')
  end

  it 'click on course details' do
    allow(Faraday).to receive(:get)
      .with('http://localhost:3000/api/v1/courses')
      .and_return(
        instance_double(
          Faraday::Response, status: 200,
                             body: File.read(Rails.root.join('spec/fixtures/courses.json'))
        )
      )
    allow(Faraday).to receive(:get)
      .with('http://localhost:3000/api/v1/courses/RUBYBASIC')
      .and_return(
        instance_double(
          Faraday::Response, status: 200,
                             body: File.read(Rails.root.join('spec/fixtures/course.json'))
        )
      )

    visit root_path
    click_on 'Ruby Basico'

    expect(page).to have_content('Ruby Basico')
    expect(page).to have_content('Um curso de Ruby')
    expect(page).to have_content('R$ 300,00')
    expect(page).to have_content('30/06/2033')
    expect(page).to have_content('RUBYBASIC')
  end

  it 'creates a course' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 200,
                                         body: '[]')
    )
    allow(Faraday).to receive(:post)
      .and_return(
        instance_double(
          Faraday::Response, status: 201,
                             body: File.read(Rails.root.join('spec/fixtures/course.json'))
        )
      )
    allow(Faraday).to receive(:get)
      .with('http://localhost:3000/api/v1/courses/RUBYBASIC')
      .and_return(
        instance_double(
          Faraday::Response, status: 200,
                             body: File.read(Rails.root.join('spec/fixtures/course.json'))
        )
      )

    visit root_path
    click_on 'Registrar um novo curso'
    fill_in 'Nome', with: 'Ruby Basico'
    fill_in 'Descrição', with: 'Um curso de Ruby'
    fill_in 'Preço', with: '300'
    fill_in 'Código', with: 'RUBYBASIC'
    fill_in 'Data limite de matrícula', with: '30/06/2033'
    fill_in 'ID do professor', with: '1'
    click_on 'Enviar'

    expect(page).to have_content('Ruby Basico')
    expect(page).to have_content('Um curso de Ruby')
    expect(page).to have_content('R$ 300,00')
    expect(page).to have_content('30/06/2033')
    expect(page).to have_content('RUBYBASIC')
  end
end
