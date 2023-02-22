def returnMax(list_):
    maxx = list_[0]

    for i in list_:
        if i > maxx:
            maxx = i

    return maxx

sortie = returnMax(list_)