class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    sql = <<-SQL
      SELECT * 
      FROM students
    SQL

    DB[:conn].execute(sql).map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    self.all.find { |student| student.name == name }
  end

  def self.all_students_in_grade_9
    self.all.select { |student| student.grade == 9 }
  end
  
  def self.students_below_12th_grade
    self.all.select { |student| student.grade < 12 }
  end

  def self.first_X_students_in_grade_10(num)
    grade_10 = self.all.select { |student| student.grade == 10 }
    return grade_10[0..num-1]
  end

  def self.first_student_in_grade_10 
    grade_10 = self.all.select { |student| student.grade == 10 }
    return grade_10.first
  end

  def self.all_students_in_grade_X(grade)
    self.all.select { |student| student.grade == grade }
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
