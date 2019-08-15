require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "csv"
require "json"

class Minitest::Test
  private

  def boston
    @boston ||= load_csv("boston.csv")
  end

  def boston_train
    @boston_train ||= Xgb::DMatrix.new(boston.data[0...300], label: boston.label[0...300])
  end

  def boston_test
    @boston_test ||= Xgb::DMatrix.new(boston.data[300..-1], label: boston.label[300..-1])
  end

  def iris
    @iris ||= load_csv("iris.csv")
  end

  def iris_train
    @iris_train ||= Xgb::DMatrix.new(iris.data[0...100], label: iris.label[0...100])
  end

  def iris_test
    @iris_test ||= Xgb::DMatrix.new(iris.data[100..-1], label: iris.label[100..-1])
  end

  def iris_binary
    @iris_binary ||= load_csv("iris.csv", binary: true)
  end

  def iris_train_binary
    @iris_train_binary ||= Xgb::DMatrix.new(iris_binary.data[0...100], label: iris_binary.label[0...100])
  end

  def iris_test_binary
    @iris_test_binary ||= Xgb::DMatrix.new(iris_binary.data[100..-1], label: iris_binary.label[100..-1])
  end

  def load_csv(filename, binary: false)
    x = []
    y = []
    CSV.foreach("test/support/#{filename}", headers: true).each do |row|
      row = row.to_a.map { |_, v| v.to_f }
      x << row[0..-2]
      y << row[-1]
    end
    y = y.map { |v| v > 1 ? 1 : v } if binary
    Xgb::DMatrix.new(x, label: y)
  end

  def regression_params
    {objective: "reg:squarederror"}
  end

  def binary_params
    {objective: "binary:logistic"}
  end

  def multiclass_params
    {objective: "multi:softprob", num_class: 3}
  end
end
