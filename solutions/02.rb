def position_ahead(snake, direction)
  head_x, head_y = snake.last
  direction_x, direction_y = direction
  [head_x + direction_x, head_y + direction_y]
end

def grow(snake, direction)
  snake.clone.push(position_ahead(snake, direction))
end

def move(snake, direction)
  grow(snake, direction).drop(1)
end

def new_food(food, snake, dimensions)
  available_positions(food, snake, dimensions).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  next_position = position_ahead(snake, direction)
  not in_bounds?(next_position, dimensions) or body_ahead?(snake, next_position)
end

def danger?(snake, direction, dimensions)
  next_position = move(snake, direction)

  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(next_position, direction, dimensions)
end

def available_positions(food, snake, dimensions)
  all_positions = playground(dimensions)
  all_positions - food - snake
end

def playground(dimensions)
  x_positions = (0...dimensions[:width]).to_a
  y_positions = (0...dimensions[:height]).to_a
  x_positions.product y_positions
end

def in_bounds?(position, dimensions)
  width = dimensions[:width]
  height = dimensions[:height]
  x, y = position

  x.between?(0, width - 1) and y.between?(0, height - 1)
end

def body_ahead?(snake, position)
  snake.include?(position)
end