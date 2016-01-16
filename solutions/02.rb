def get_next_position(snake, direction)
  head = snake.last
  [head[0] + direction[0], head[1] + direction[1]]
end

def out_of_bounds?(position, dimensions)
  width = dimensions[:width]
  height = dimensions[:height]
  x = position[0]
  y = position[1]

  x < 0 or x >= width or y < 0 or y >= height
end

def grow(snake, direction)
  snake.dup.push(get_next_position(snake, direction))
end

def move(snake, direction)
  snake.drop(1).push(get_next_position(snake, direction))
end

def new_food(food, snake, dimensions)
  newly_generated_food = [rand(dimensions[:width]), rand(dimensions[:height])]

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