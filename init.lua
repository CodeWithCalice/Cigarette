local function apply_hud_effect(player, base_texture, duration, intensity)
    if not player or not player:is_player() then return end

    local meta = player:get_meta()
    local old_id = meta:get_int("cigarette:hud_id")

    if old_id and old_id ~= 0 then
        player:hud_remove(old_id)
    end

    local id_img = player:hud_add({
        hud_elem_type = "image",
        position = {x = 0.5, y = 0.5},
        scale = {x = -150, y = -150},
        text = base_texture,
        alignment = {x = 0, y = 0},
    })

    local id = player:hud_add({
        hud_elem_type = "image",
        position = {x = 0.5, y = 0.5},
        scale = {x = -150, y = -150},
        text = base_texture,
        alignment = {x = 0, y = 0},
    })

    meta:set_int("cigarette:hud_id_img", id_img)
    meta:set_int("cigarette:hud_id", id)

    local t = 0
    local step = 0.05

    local function animate()
        if not player or not player:is_player() then return end

        t = t + step

        local offset_x1 = math.sin(t * 2) * intensity * 20
        local offset_y1 = math.cos(t * 1.5) * intensity * 20

        player:hud_change(id, "offset", {
            x = offset_x1,
            y = offset_y1
        })

        local offset_x2 = math.sin((t + 0.5) * 2.2) * intensity * 35 + 10
        local offset_y2 = math.cos((t + 0.3) * 1.8) * intensity * 35 - 10

        player:hud_change(id_img, "offset", {
            x = offset_x2,
            y = offset_y2
        })

        player:hud_change(id, "text",
            base_texture .. "^[opacity:" .. (60 + intensity * 80)
        )

        local r = math.floor(128 + math.sin(t * 3) * 127)
        local g = math.floor(128 + math.sin(t * 2) * 127)
        local b = math.floor(128 + math.sin(t * 4) * 127)
        local color = string.format("#%02X%02X%02X", r, g, b)

        player:hud_change(id_img, "text",
            base_texture .. "^[colorize:" .. color .. ":" .. (100 + intensity * 120)
        )

        local scale1 = -150 + math.sin(t * 2) * intensity * 10
        local scale2 = -170 + math.cos(t * 2.5) * intensity * 15

        player:hud_change(id, "scale", {x = scale1, y = scale1})
        player:hud_change(id_img, "scale", {x = scale2, y = scale2})

        minetest.after(step, animate)
    end

    animate()

    minetest.after(duration, function()
        if player and player:is_player() then
            player:hud_remove(id_img)
            player:hud_remove(id)
            meta:set_int("cigarette:hud_id_img", 0)
            meta:set_int("cigarette:hud_id", 0)
        end
    end)
end

core.register_craftitem("cigarette:cigarette", {
    description = "Cigarette",
    inventory_image = "cigarette.png",

    on_use = function(itemstack, user)
        apply_hud_effect(user, "smoke_overlay.png^[opacity:80", 3, 0.3)
        itemstack:take_item()
        return itemstack
    end,
})

core.register_craftitem("cigarette:blunt", {
    description = "Blunt",
    inventory_image = "blunt.png",

    on_use = function(itemstack, user)
        apply_hud_effect(user, "smoke_overlay.png^[colorize:#88FF88:120", 5, 0.5)
        itemstack:take_item()
        return itemstack
    end,
})

core.register_craftitem("cigarette:joint", {
    description = "Joint",
    inventory_image = "joint.png",

    on_use = function(itemstack, user)
        apply_hud_effect(user, "smoke_overlay.png^[colorize:#AAFFAA:180", 7, 0.7)
        itemstack:take_item()
        return itemstack
    end,
})

core.register_craft({
    output = "cigarette:cigarette",
    recipe = {
        {"", "default:paper", ""},
        {"", "default:coal_lump", ""},
        {"", "default:paper", ""},
    },
})

core.register_craft({
    output = "cigarette:blunt",
    recipe = {
        {"", "default:paper", "default:paper"},
        {"", "farming:weed", "farming:weed"},
        {"", "default:paper", "default:paper"},
    },
})

core.register_craft({
    output = "cigarette:joint",
    recipe = {
        {"", "default:paper", ""},
        {"", "farming:weed", ""},
        {"", "default:paper", ""},
    },
})