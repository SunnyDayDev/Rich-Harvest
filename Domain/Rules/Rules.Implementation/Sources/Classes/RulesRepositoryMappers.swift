//
// Created by Александр Цикин on 2018-11-19.
//

import Foundation

class RulesRepositoryMappers {

    var fromApi: FromApi { return FromApi() }

    var fromPlain: FromPlain { return FromPlain() }

    class FromApi {

        var toPlain: ToPlain { return ToPlain() }

        class ToPlain {

        }

    }

    class FromPlain {

        var toApi: ToApi { return ToApi() }

        class ToApi {

        }

    }

}