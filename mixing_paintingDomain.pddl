(define (domain hello)

(:requirements :strips :typing :negative-preconditions :fluents :durative-actions)

(:types room layer mixer)

(:predicates
    (paintready ?r - room)
    (available ?r - room)
    (painted ?r - room)
    (ready ?m - mixer)
)

(:functions
    (time_mix ?l - layer)
    (time_paint ?l - layer)
)

; todo: turn this into a durative-action with a proper duration
(:durative-action paint
    :parameters (?r - room ?m - mixer ?l - layer)
    :duration (= ?duration (time_paint ?l))
    :condition (and
        (at start(and
            (available ?r)
            (not (painted ?r))
            (ready ?m)
            (paintready ?r)
        ))
    )
    :effect (and
        (at start (and
        (not(ready ?m))
        (not(available ?r))
        ))
        (at end (and
        (ready ?m)
        (painted ?r)
        (available ?r)
        ))

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
    )
    :effect (and 
        (at start (and 
            (not (ready ?m))
            (not(available ?r))
        ))
        (at end (and 
            (ready ?m)
            (paintready ?r)
            (available ?r)
        ))
    )
)
)