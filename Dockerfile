FROM php:8.1-cli

# Instalar dependências
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Diretório de trabalho
WORKDIR /var/www

# Copiar arquivos do projeto
COPY . .

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Instalar dependências Laravel
RUN composer install --no-dev

# Gerar chave (ignora erro se já existir)
RUN php artisan key:generate || true

# Expor porta usada pelo artisan serve
EXPOSE 8000

# Comando que mantém o servidor Laravel rodando corretamente
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
