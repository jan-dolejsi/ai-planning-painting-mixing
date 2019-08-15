(define (domain hello)

(:requirements :strips :typing :negative-preconditions)

(:types room layer mixer)

(:predicates
    (paintready ?r - room)
    (available ?r - room)
    (painted ?r - room)
    (ready ?m - mixer)
)

(:functions
    (time_mix ?l - layer)
)

(:action paint
    :parameters (?r - room)
    :precondition (and

        (not (painted ?r))

        (paintready ?r)
    )
    :effect (and

        (painted ?r)
    )
)


)
(:durative-action mix
    :parameters (?r - room ?m - mixer ?l - layer)
    :duration (= ?duration (time_mix ?l))
    :condition (and 
        (at start (and 
            (available ?r)
            (not (paintready ?r))
            (ready ?m)
        ))
        (over all (and
            (not(ready ?m))
        ))
        (at end (and
            (ready ?m))
        ))
    )
    :effect (and 
        (at start (and 
            (not (ready ?m))
        ))
        (at end (and 
            (ready ?m)
            (paintready ?r)
        ))
    )
)

)