while read -r line < /dev/ttyACM0; do
  # $line is the line read, do something with it
  echo $line
  echo "hey"
done
