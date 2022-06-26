module SitesHelper
  include CheckHelper

  def domain_cell(domain, grade)
    link = link_to domain, https_show_path(domain)
    content_tag :th, (rank_label(grade) + ' ' + link).html_safe
  end

  def tls_cell(tls)
    return unless tls
    color   = case tls.to_sym
              when :tls1_2_only
                :success
              when :tls1_2
                :error
              else
                :critical
              end
    content = content_tag :div, color, class: %i[sr-only]
    content_tag :td, label(' ' + content, color), class: %i[text-center]
  end

  def ciphers_cell(ciphers)
    return unless ciphers
    color   = case ciphers.to_sym
              when :good
                :success
              else
                :critical
              end
    content = content_tag :div, color, class: %i[sr-only]
    content_tag :td, label(' ' + content, color), class: %i[text-center]
  end

  def pfs_cell(pfs)
    return unless pfs
    color   = case pfs.to_sym
              when :pfs_only
                :success
              when :pfs
                :error
              else
                :critical
              end
    content = content_tag :div, color, class: %i[sr-only]
    content_tag :td, label(' ' + content, color), class: %i[text-center]
  end
end
