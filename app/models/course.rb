class Course
  attr_reader :name, :description, :instructor, :code, :price, :enrollment_deadline

  def initialize(name: nil, description: nil, instructor: nil, code: nil, price: nil, enrollment_deadline: nil)
    @name = name
    @description = description
    @instructor = instructor
    @code = code
    @price = price
    @enrollment_deadline = enrollment_deadline&.to_date
  end

  def self.all
    response = Faraday.get 'http://localhost:3000/api/v1/courses'
    return [] unless response.status == 200

    courses = JSON.parse(response.body, symbolize_names: true)
    courses.map do |course|
      new(name: course[:name],
          description: course[:description],
          instructor: course[:instructor],
          code: course[:code],
          price: course[:price],
          enrollment_deadline: course[:enrollment_deadline])
    end
  rescue Faraday::ConnectionFailed
    []
  rescue Faraday::TimeoutError
    []
  end

  def self.find(code)
    response = Faraday.get "http://localhost:3000/api/v1/courses/#{code}"
    course = JSON.parse(response.body, symbolize_names: true)
    new(name: course[:name],
        description: course[:description],
        code: course[:code],
        price: course[:price],
        enrollment_deadline: course[:enrollment_deadline])
  end

  def self.create(attributes = {})
    response = Faraday.post(
      'http://localhost:3000/api/v1/courses',
      { course: attributes }.to_json,
      'Content-type': 'application/json'
    )
    course = JSON.parse(response.body, symbolize_names: true)
    new(name: course[:name],
      description: course[:description],
      code: course[:code],
      price: course[:price],
      enrollment_deadline: course[:enrollment_deadline])
  end
end
