require 'fastlane/action'
require 'octokit'

module Fastlane
  module Actions
    class CommentOnPullRequestAction < Action
      def self.run(params)
        github_token = params[:github_token]
        repo = params[:repo]
        pr_number = params[:pr_number]
        comment = params[:comment]

        # Crear un cliente de Octokit
        client = Octokit::Client.new(access_token: github_token)

        begin
          # Crear un comentario en el Pull Request
          client.add_comment(repo, pr_number, comment)
          UI.success("Comentario agregado al PR ##{pr_number} con éxito")
        rescue StandardError => e
          UI.error("Hubo un error al agregar el comentario: #{e.message}")
        end
      end

      # Definir los parámetros necesarios para la acción
      def self.description
        "Añadir un comentario a un Pull Request en GitHub"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :github_token,
                                       description: "Token de acceso personal de GitHub",
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :repo,
                                       description: "Repositorio de GitHub (por ejemplo, usuario/repositorio)",
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :pr_number,
                                       description: "Número del Pull Request al que agregar el comentario",
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :comment,
                                       description: "Comentario a agregar al Pull Request",
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios # O cualquier plataforma que estés utilizando
      end
    end
  end
end
