class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.name = row[1]
    student.grade = row[2]
    student.id = row[0]
    student
  end

  def self.all
    sql = "SELECT * FROM students"
    students = DB[:conn].execute(sql)
    students.collect {|student| self.new_from_db(student)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    student = DB[:conn].execute(sql, name).collect {|row| self.new_from_db(row)}[0]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "9"
    SQL

    DB[:conn].execute(sql).collect {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE NOT grade = "12"
    SQL

    DB[:conn].execute(sql).collect {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "10"
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x).collect {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = "10"
      LIMIT 1
    SQL

    DB[:conn].execute(sql).collect {|row| self.new_from_db(row)}[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x.to_s).collect {|row| self.new_from_db(row)}
  end
end
