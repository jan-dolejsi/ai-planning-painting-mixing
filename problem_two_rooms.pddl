(define (problem two_rooms)

    (:domain hello)

    (:objects

        room1 - room
        room2 - room
        john - mixer

        layer1 - layer
    )

    (:init

        (available room1)
        (available room2)
        (ready john)

        (= (time_mix layer1) 3)
        (= (time_paint layer1) 2)
    )

    (:goal
        (and
            (painted room1 layer1)
            (painted room2 layer1)
        )
    )
)