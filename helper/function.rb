def string_to_arr(str)
  return str.tr("[", "").tr("]", "").tr(" ", "").split(",")
end
