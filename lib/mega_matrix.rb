# frozen_string_literal: true

require_relative "mega_matrix/version"

module MegaMatrix
  class Error < StandardError; end

  def self.help # Не забыть описать!!!
    puts "Тут и так все понято"
  end
  class Matrix
    attr_reader :data

    # Инициализация: принимает двумерный массив
    def initialize(data)
      raise ArgumentError, "Данные должны быть двумерным массивом" unless data.is_a?(Array) && data.all? { |row| row.is_a?(Array) }
      @data = data
    end

    # Чтение элемента
    def [](i, j)
      Accesstrix.get(@data, i, j)
    end

    #Запись элемента
    def []=(i, j, value)
      Accesstrix.set(@data, i, j, value)
    end

    # Получение строки
    def row(i)
      self.class.new([Accesstrix.row(@data, i)])
    end

    # Получение столбца
    def column(j)
      self.class.new(Accesstrix.column(@data, j).map { |val| [val] })
    end

    # Вставка строки
    def insert_row(index, row)
      row_data = row.is_a?(Matrix) ? row.to_a.flatten : row
      new_data = Accesstrix.insert_row(@data, index, row_data)
      self.class.new(new_data)
    end

    # Вставка столбца
    def insert_column(index, column)
      column_data = column.is_a?(Matrix) ? column.to_a.flatten : column
      new_data = Accesstrix.insert_column(@data, index, column_data)
      self.class.new(new_data)
    end

    # Удаление строки
    def delete_row(index)
      new_data = Accesstrix.delete_row(@data, index)
      self.class.new(new_data)
    end
  
    # Удаление столбца
    def delete_column(index)
      new_data = Accesstrix.delete_column(@data, index)
      self.class.new(new_data)
    end

    # Обмен строк
    def swap_rows(i, j)
      new_data = Accesstrix.swap_rows(@data, i, j)
      self.class.new(new_data)
    end

    # Обмен столбцов
    def swap_columns(i, j)
      new_data = Accesstrix.swap_columns(@data, i, j)
      self.class.new(new_data)
    end

    def to_s
      Genetrix.pprint(@data)
    end

    def to_a
      @data
    end
  end
end

# 1. Создание матриц (можно использовать как шаблон)
module Genetrix
  class Error < StandardError; end

  # Генерация матрицы
  def self.new(rows = 1, colums = 1, elem = 0)
    matrix = []

    for i in 0...rows
      new_row = []
      for j in 0...colums
        new_row << elem
      end
      matrix << new_row
    end

    matrix
  end

  # Красивый вывод
  def self.pprint(matrix)
    matrix_temp = matrix.dup
    max_width = matrix_temp.flatten.map { |e| e.to_s.length }.max

    matrix_temp.map do |row|
      row.map { |e| e.to_s.rjust(max_width) }.join(" ")
    end.join("\n")
    
  end
end


# 2. Доступ к элементам и изменение
module Accesstrix
  class Error < StandardError; end
  
  # Чтение элемента по индексам
  def self.get(matrix, i, j)
    validate_indices!(matrix, i, j)
    matrix[i][j]
  end
  
  # Запись элемента по индексам
  def self.set(matrix, i, j, value)
    validate_indices!(matrix, i, j)
    matrix[i][j] = value
  end
  
  # Получение строки матрицы
  def self.row(matrix, i)
    validate_row_index!(matrix, i)
    matrix[i].dup
  end
  
  # Получение столбца матрицы
  def self.column(matrix, j)
    validate_column_index!(matrix, j)
    matrix.map { |row| row[j] }
  end
  
  # Вставка строки
  def self.insert_row(matrix, index, row)
    validate_insert_row_index!(matrix, index)
    validate_row_data!(row, matrix.empty? ? row.size : matrix[0].size)
    
    new_matrix = matrix.dup
    new_matrix.insert(index, row.dup)
    new_matrix
  end

  # Вставка столбца
  def self.insert_column(matrix, index, column)
    validate_insert_column_index!(matrix, index)
    validate_column_data!(column, matrix.size)
    
    new_matrix = matrix.map(&:dup)
    new_matrix.each_with_index do |row, i|
      row.insert(index, column[i])
    end
    new_matrix
  end

  # Удаление строки
  def self.delete_row(matrix, index)
    validate_row_index!(matrix, index)
    new_matrix = matrix.dup
    new_matrix.delete_at(index)
    new_matrix
  end

  # Удаление столбца
  def self.delete_column(matrix, index)
    validate_column_index!(matrix, index)
    new_matrix = matrix.map(&:dup)
    new_matrix.each { |row| row.delete_at(index) }
    new_matrix
  end

  # Обмен строк местами
  def self.swap_rows(matrix, i, j)
    validate_row_index!(matrix, i)
    validate_row_index!(matrix, j)
    new_matrix = matrix.dup
    new_matrix[i], new_matrix[j] = new_matrix[j], new_matrix[i]
    new_matrix
  end

  # Обмен столбцов местами
  def self.swap_columns(matrix, i, j)
    validate_column_index!(matrix, i)
    validate_column_index!(matrix, j)
    new_matrix = matrix.map(&:dup)
    new_matrix.each do |row|
      row[i], row[j] = row[j], row[i]
    end
    new_matrix
  end

  # Проверка валидности индексов
  def self.validate_indices!(matrix, i, j)
    validate_row_index!(matrix, i)
    validate_column_index!(matrix, j)
  end
  
  def self.validate_row_index!(matrix, i)
    raise ArgumentError, "Индекс строки #{i} вне диапазона" unless i.is_a?(Integer) && i >= 0 && i < matrix.size
  end
  
  def self.validate_column_index!(matrix, j)
    return if matrix.empty?
    raise ArgumentError, "Индекс столбца #{j} вне диапазона" unless j.is_a?(Integer) && j >= 0 && j < matrix[0].size
  end

  def self.validate_insert_row_index!(matrix, index)
    max_index = matrix.size
    raise ArgumentError, "Индекс вставки #{index} вне диапазона (0..#{max_index})" unless index.is_a?(Integer) && index >= 0 && index <= max_index
  end

  def self.validate_insert_column_index!(matrix, index)
    max_index = matrix.empty? ? 0 : matrix[0].size
    raise ArgumentError, "Индекс вставки #{index} вне диапазона (0..#{max_index})" unless index.is_a?(Integer) && index >= 0 && index <= max_index
  end

  def self.validate_row_data!(row, expected_size)
    raise ArgumentError, "Строка должна быть массивом" unless row.is_a?(Array)
    unless expected_size == 0 || row.size == expected_size
      raise ArgumentError, "Длина строки (#{row.size}) не соответствует размеру матрицы (#{expected_size})"
    end
  end

  def self.validate_column_data!(column, expected_size)
    raise ArgumentError, "Столбец должен быть массивом" unless column.is_a?(Array)
    unless column.size == expected_size
      raise ArgumentError, "Длина столбца (#{column.size}) не соответствует количеству строк матрицы (#{expected_size})"
    end
  end
  
  private_class_method :validate_indices!, :validate_row_index!, :validate_column_index!
end


# 3. Арифметические операции
module Arifmetrix
  class Error < StandardError; end
  # Тут писать функции
end


# 4. Линейная алгебра и численные методы
module Linetrix
  class Error < StandardError; end
  # Тут писать функции
end


# 5. Преобразования и специальные операции
module Spectrix
  class Error < StandardError; end
  # Тут писать функции
end