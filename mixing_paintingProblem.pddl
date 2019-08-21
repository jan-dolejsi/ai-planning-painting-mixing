;;!pre-parsing:{type: "nunjucks", data: "defaults.json"}

; hints: https://mozilla.github.io/nunjucks/templating.html

(define (problem {{data.problem}})

(:domain painting)

(:objects

    {% for r in range(1, data.rooms+1) %}
    room{{r}} - room
    {%endfor%}

    {% for l in range(1, data.mixers+1) %}
    mixer{{l}} - mixer
    {%endfor%}

    {% for e in range(1, data.layers+1) %}
    layer{{e}} - layer
    {%endfor%}
)

(:init

    {% for r in range(1, data.rooms+1) %}
    (available room{{r}})
    {% if data.layers %}    (current layer1 room{{r}}) {% endif %}
    {% endfor %}

    {% if data.rooms %}    (painters_in room1) {% endif %}

    ; room sequence (circular)
    {% for r in range(2, data.rooms+1)%}
    (next_room room{{r-1}} room{{r}})
    {% endfor %}
    {% if data.rooms %}    (next_room room{{data.rooms}} room1){% endif %}

    ; layer sequence
    {% for l in range(2, data.layers+1)%}
    (next_layer layer{{l-1}} layer{{l}})
    {% endfor %}

    {% for k in range(1, data.mixers+1) %}
    (ready mixer{{k}})
    {%endfor%}

    {% for layer in data.time_mix %}
    (= (time_mix layer{{loop.index}}) {{layer}})
    {%endfor%}

    {% for layer in data.time_paint %}
    (= (time_paint layer{{loop.index}}) {{layer}})
    {%endfor%}

    (= (time_clean) {{data.time_clean}})

    {% if data.disposable_brush %}
    (disposable_brush)    
    {% endif %}
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