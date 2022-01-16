local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')

vRP = Proxy.getInterface('vRP')
vRPclient = Proxy.getInterface('vRP', "vrp_identity")
vRPCIden = Tunnel.getInterface('vrp_identity', 'vrp_identity')

local vRPSIden = {}
Tunnel.bindInterface("vrp_identity", vRPSIden)
Proxy.addInterface("vrp_identity", vRPSIden)

--[[

    ALTER TABLE vrp_users ADD inreg INT(1) NOT NULL DEFAULT '0'

]]

AddEventHandler("vRP:playerSpawn", function(_id, _src, fs)
    if _id ~= nil then
        if fs then
            local data <const> = exports.ghmattimysql:executeSync("SELECT inreg FROM vrp_users WHERE id = @_id", {["@_id"] = _id})
            if data[1].inreg == 0 then vRPCIden.createIdentityUI(_src,{}) end
        end
    end
end)

vRPSIden.updateUI = function(nume, prenume, varsta)
    local _src <const> = source
    local _id <const> = vRP.getUserId({_src})
    if _id ~= nil then
        vRP.generateRegistrationNumber({function(registration)
            vRP.generatePhoneNumber({function(phone)
                exports.ghmattimysql:execute("UPDATE vrp_user_identities SET firstname = @nume, name = @prenume, age = @varsta, registration = @registration, phone = @phone WHERE id = @id", {
                    ["@id"] = _id,
                    ["nume"] = nume,
                    ["prenume"] = prenume,
                    ["varsta"] = varsta,
                    ["registration"] = registration,
                    ["phone"] = phone
                })
                exports.ghmattimysql:execute("UPDATE vrp_users SET inreg = @inreg WHERE id = @id", { ["@id"] = _id, ["inreg"] = 1 })
                vRPclient.setRegistrationNumber(_src,{registration})
            end})
        end})
    end
end
