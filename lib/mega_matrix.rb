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

# 1. Создание матриц (можно использовать как шаблон) (Юра)
module Genetrix
  class Error < StandardError; end


  def self.new(rows = 1, cols = 1, elem = 0)
    matrix = []

    for i in 0...rows
      row = []
      for j in 0...cols
        row << elem
      end
      matrix << row
    end

    matrix
  end

  def self.from_array(array)
    unless array.is_a?(Array) && array.all? { |row| row.is_a?(Array) }
      raise Error, "Ожидается двумерный массив"
    end

    row_size = array[0].size

    unless array.all? { |row| row.size == row_size }
      raise Error, "Все строки должны быть одинаковой длины"
    end

    # Делаем копию, чтобы избежать мутаций
    array.map(&:dup)
  end

  # Красивый вывод
  def self.pprint(matrix)
    matrix_temp = matrix.respond_to?(:to_a) ? matrix.to_a : matrix
    max_width = matrix_temp.flatten.map { |e| e.to_s.length }.max

    matrix_temp.map do |row|
      row.map { |e| e.to_s.rjust(max_width) }.join(" ")
    end.join("\n")
      end

  # Нулевая
  def self.zero(rows, cols = rows)
    new(rows, cols, 0)
  end

  # Единичная
  def self.identity(n)
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = 1
    end

    matrix
  end

  # Заполненная значением
  def self.fill(rows, cols, value)
    new(rows, cols, value)
  end

  # Случайная
  def self.random(rows, cols, range = 0..1)
    matrix = []

    (0...rows).each do
      row = []
      (0...cols).each do
        row << rand(range)
      end
      matrix << row
    end

    matrix
  end

  # По функции (i, j)
  def self.from_function(rows, cols)
    raise Error, "Нужен блок!" unless block_given?

    matrix = []

    (0...rows).each do |i|
      row = []
      (0...cols).each do |j|
        row << yield(i, j)
      end
      matrix << row
    end

    matrix
  end

  # Диагональная
  def self.diagonal(*values)
    n = values.size
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = values[i]
    end

    matrix
  end

  # Скалярная
  def self.scalar(n, value)
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = value
    end

    matrix
  end

  # Матрица Гильберта
  def self.hilbert(n)
    matrix = []

    (0...n).each do |i|
      row = []
      (0...n).each do |j|
        row << 1.0 / (i + j + 1)
      end
      matrix << row
    end

    matrix
  end

  # Копия матрицы
  def self.copy(matrix)
    matrix.map(&:dup)
  end

  # Размер
  def self.shape(matrix)
    [matrix.size, matrix[0].size]
  end

  # Транспонирование (простое)
  def self.transpose(matrix)
    rows = matrix.size
    cols = matrix[0].size

    result = new(cols, rows, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[j][i] = matrix[i][j]
      end
    end

    result
  end
end


# 2. Доступ к элементам и изменение (Тёма)
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


# 3. Арифметические операции (Миша)
module Arifmetrix
  class Error < StandardError; end

  def self.plus(matrix_1, matrix_2)
    check_sizes(matrix_1, matrix_2)

    rows = matrix_1.size
    cols = matrix_1[0].size

    result = Genetrix.new(rows, cols, 0)   

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix_1[i][j] + matrix_2[i][j]
      end
    end
    result
  end

  def self.minus(matrix_1, matrix_2)
    check_sizes(matrix_1, matrix_2)

    rows = matrix_1.size
    cols = matrix_1[0].size

    result = Genetrix.new(rows, cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix_1[i][j] - matrix_2[i][j]
      end
    end
    result
  end

  def self.multi_scalar(matrix, scalar)
    raise Error, "Скаляр должен быть числом" unless scalar.is_a?(Numeric)

    rows = matrix.size
    cols = matrix[0].size

    result = Genetrix.new(rows, cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix[i][j] * scalar
      end
    end
    result
  end

  def self.multi_matrix(matrix_1, matrix_2)
    # Проверка совместимости: число столбцов первой = число строк второй
    if matrix_1[0].size != matrix_2.size
      raise Arifmetrix::Error, "Несовместимые размеры для умножения"
    end

    rows = matrix_1.size
    cols = matrix_2[0].size
    common = matrix_1[0].size  # общая размерность

    # Создаём нулевую матрицу результата через Genetrix
    result = Genetrix.new(rows, cols, 0)

    # Основные циклы умножения
    (0...rows).each do |i|
      (0...cols).each do |j|
        sum = 0
        (0...common).each do |k|
          sum += matrix_1[i][k] * matrix_2[k][j]
        end
        result[i][j] = sum
      end
    end

    result
  end

  def self.div_scalar(matrix, scalar)
    raise Arifmetrix::Error, "Деление на ноль" if scalar == 0
    self.multi_scalar(matrix, 1.0 / scalar)
  end

  def self.degree_matrix(matrix, n)
    raise Arifmetrix::Error, "Степень должна быть целочисленной" unless n.is_a?(Integer)
    raise Arifmetrix::Error, "Степень должна быть неотрицательной" if n < 0
    raise Arifmetrix::Error, "матрица должна быть квадратной" unless matrix.size == matrix[0].size

    return Genetrix.identity_matrix(matrix.size) if n == 0
    
    result = matrix.dup
    (n - 1).times do
      result = self.multi_matrix(result, matrix)
    end

    result
  end

  def self.hadamard_product(matrix_1, matrix_2)
    check_sizes(matrix_1, matrix_2)

    rows = matrix_1.size
    cols = matrix_1[0].size

    result = Genetrix.new(rows, cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix_1[i][j] * matrix_2[i][j]
      end
    end

    result
  end

  private

  def self.check_sizes(matrix_1, matrix_2)
    if matrix_1.size != matrix_2.size || matrix_1[0].size != matrix_2[0].size
      raise Error, "Bad sizes!"
    end
  end

end


# 4. Линейная алгебра и численные методы (Толя)
module Linetrix
  class Error < StandardError; end
  # Тут писать функции
end


# 5. Преобразования и специальные операции (Давид)
module Spectrix
  class Error < StandardError; end
  # Тут писать функции
end