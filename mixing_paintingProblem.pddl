

(define (problem hello-world)

(:domain hello)

(:objects

    room1 - room
    room2 - room
    john - mixer
)

(:init

    (available room1)
    (available room2)
    (ready john)
)

(:goal
    (and

        (painted room1)
        (painted room2)
    )
)
)