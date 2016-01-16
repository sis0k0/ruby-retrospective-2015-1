def get_next_position(snake, direction)
  head = snake.last
  next_position = [head[0] + direction[0], head[1] + direction[1]]

  next_position
end

def out_of_bounds?(position, dimensions)
  width = dimensions[:width]
  height = dimensions[:height]
  x = position[0]
  y = position[1]

  x < 0 or x >= width or y < 0 or y >= height
end

def grow(snake, direction)
  next_position = get_next_position(snake, direction)
  snake.push next_position

  snake
end

def move(snake, direction)
  grow(snake, direction)
  snake.delete_at(0)

  snake
end

def new_food(food, snake, dimensions)
  x = rand(dimensions[:width])
  y = rand(dimensions[:height])
  newly_generated_food = [x, y]

  if snake.include?(newly_generated_food) or food.include?(newly_generated_food)
    new_food(food, snake, dimensions)
  else
    newly_generated_food
  end
end

def obstacle_ahead?(snake, direction, dimensions)
  next_position = get_next_position(snake, direction)
  out_of_bounds = out_of_bounds?(next_position, dimensions)

  out_of_bounds or snake.include?(next_position)
end

def danger?(snake, direction, dimensions)
  obstacle_one_turn = obstacle_ahead?(snake, direction, dimensions)

  next_position = move(snake, direction)
  obstacle_two_turns = obstacle_ahead?(next_position, direction, dimensions)

  obstacle_one_turn or obstacle_two_turns
end