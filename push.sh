while (true)
do
{
    git push
    if [ $? -eq 0 ]; then
        break
    fi
}
done