;;!pre-parsing:{type: "nunjucks", data: "data.json"}

; hints: https://mozilla.github.io/nunjucks/templating.html

(define (problem {{data.username}})

(:domain hello)

(:objects

    {% for r in range(1, data.rooms+1) %}
    room{{r}} - room
    {%endfor%}
    {% for l in range(1, data.mixers+1) %}
    mixer{{l}} - mixer
    {%endfor%}

    ; todo: replace by a nunjucks for loop
    {% for e in range(1, data.layers+1) %}
    layer{{e}} - layer
    {%endfor%}

    ; ; todo: replace by a loop from data.json
    ; john - mixer
)

(:init

    ; todo: replace by a loop from data.json
    {% for r in range(1, data.rooms+1) %}
    (available room{{r}})
    {%endfor%}

    ; todo: replace by a loop from data.json
    {% for k in range(1, data.mixers+1) %}
    (ready mixer{{k}})
    {%endfor%}

    {% for rhyme in data.time_mix %}
    (= (time_mix layer{{loop.index}}) {{rhyme}})
    {%endfor%}
    {% for ji in data.time_paint %}
    (= (time_paint layer{{loop.index}}) {{ji}})
    {%endfor%}

)

(:goal
    (and

    {% for r in range(1, data.rooms+1) %}   
        {% for l in range(1, data.layers+1) %} 
            (painted room{{r}} layer{{l}})
        {%endfor%}
    {%endfor%}
    )
)
)