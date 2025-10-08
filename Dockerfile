# Imagem base do PHP com extensões necessárias
FROM php:8.1-cli

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Copiar o projeto Laravel para dentro do container
COPY . /var/www

WORKDIR /var/www

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Instalar dependências do Laravel
RUN composer install --no-dev

# Gerar chave da aplicação
RUN php artisan key:generate

# Expor a porta padrão do Laravel
EXPOSE 8000

# Comando para iniciar o servidor Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
