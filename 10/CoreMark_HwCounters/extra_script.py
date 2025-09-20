Import("env")
env.Append(
  LINKFLAGS=[
      "-Wa,-march=rv32im",
      "-march=rv32im"
  ]
)
