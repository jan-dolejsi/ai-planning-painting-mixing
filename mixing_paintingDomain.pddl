

(define (domain hello)

(:requirements :strips :typing :negative-preconditions)

(:types room layer mixer)

(:predicates
    (paintready ?r - room)
    (available ?r - room)
    (painted ?r - room)
    (ready ?m - mixer)
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
    :parameters (?r - room ?m - mixer)
    :duration (= ?duration 1)
    :condition (and 
        (at start (and 
            (available ?r)
            (not (paintready ?r))
            (ready ?m)
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