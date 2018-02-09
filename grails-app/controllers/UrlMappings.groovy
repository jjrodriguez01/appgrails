class UrlMappings {

    static mappings = {
        "/mapper/home"(view:'/mapper/home')
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/"(controller:"user",action:"renderIndex")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
