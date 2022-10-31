#!/user/bin/bash

for ((j=1, j<=10, j++)); do

N1 = 1024

for ((i=1, i<=10, i++)); do
	./slow N1
	N1 = $((1024 + N1))
done

N1 = 1024

for ((i=1, i<=10, i++)); do
	./fast N1
	N1 = $((1024 + N1))
done

done
